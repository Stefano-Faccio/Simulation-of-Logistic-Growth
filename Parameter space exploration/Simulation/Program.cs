using System.Globalization;
using System;
using System.Collections;
using System.Linq;

//Heatmap con START_POPULATION e CROWDING_COEFFICIENT

namespace LogisticSimulation
{
    internal class Program
    {
        //Initial population
        const int START_START_POPULATION = 1;
        const int END_START_POPULATION = 51;
        const int STEP_START_POPULATION = 2;
        //Crowding coefficient
        const decimal START_CROWDING_COEFFICIENT = 0.00001M;
        const decimal END_CROWDING_COEFFICIENT = 0.0001M;
        const decimal STEP_CROWDING_COEFFICIENT = 0.00001M;
        //Reproduction and death probability
        const decimal START_REPRODUCTION_PROBABILITY = 0.05M;
        const decimal END_REPRODUCTION_PROBABILITY = 1M;
        const decimal STEP_REPRODUCTION_PROBABILITY = 0.05M;
        //Number of simulations and iterations
        static int NSIMULATIONS = 100;
        static int ITERATIONS = 500;
        //Growth rate
        static decimal R_D = 0.05M;

        static void Main(string[] args)
        {
            //Initial setup
            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture; // Decimal numbers are printed with dot and not comma
            string path = "data.txt";

            //Check if the user has passed command line arguments
            if (args.Length == 3)
            {
                try
                {
                    NSIMULATIONS = Int32.Parse(args[0]);
                    ITERATIONS = Int32.Parse(args[1]);
                    R_D = Decimal.Parse(args[2]);
                    Console.WriteLine($"NSIMULATIONS: {NSIMULATIONS}");
                    Console.WriteLine($"ITERATIONS: {ITERATIONS}");
                    Console.WriteLine($"R_D: {R_D}");
                }
                catch
                {
                    NSIMULATIONS = 50;
                    ITERATIONS = 300;
                    Console.WriteLine("Usage: ./exe {NSIMULATIONS} {ITERATIONS} {R_D}");
                }
            }

            //----------------------//

            //Initialization of the lists with start populations, crowding coefficients, reproduction and death probabilities
            List<int> startPopulations = new();
            for (int value = START_START_POPULATION; value <= END_START_POPULATION; value += STEP_START_POPULATION)
                startPopulations.Add(value);

            List<double> crowdingCoefficients = new();
            for (decimal value = START_CROWDING_COEFFICIENT; value <= END_CROWDING_COEFFICIENT; value += STEP_CROWDING_COEFFICIENT)
                crowdingCoefficients.Add((double)value);

            List<double> reproductionProbabilities = new();
            List<double> deathProbabilities = new();
            for (decimal value = START_REPRODUCTION_PROBABILITY; value <= END_REPRODUCTION_PROBABILITY; value += STEP_REPRODUCTION_PROBABILITY)
            {
                reproductionProbabilities.Add((double)value);
                deathProbabilities.Add((double)(value- R_D));
            }
            string[,,] results = new string[startPopulations.Count, crowdingCoefficients.Count, reproductionProbabilities.Count];

            //Print the progress bar to the console
            Console.ForegroundColor = ConsoleColor.Green;
            Console.Write("[");
            for (int i = 0; i < startPopulations.Count; i++)
            {
                if (i == startPopulations.Count / 2)
                    Console.Write("%");
                else
                    Console.Write("-");
            }
                
            Console.WriteLine("]");
            Console.ResetColor();
            Console.Write("[");
            
            //Run the simulations
            MultipleSimulations(startPopulations, crowdingCoefficients, reproductionProbabilities, deathProbabilities, results);

            Console.WriteLine("]");

            //----------------------//

            //Write the results to a file
            File.Delete(path);
            StreamWriter file = File.AppendText(path);
            file.WriteLine("NSIMULATIONS ITERATIONS R_D");
            file.WriteLine($"{NSIMULATIONS} {ITERATIONS} {R_D}");
            file.WriteLine("START_START_POPULATION STEP_POPULATION END_START_POPULATION");
            file.WriteLine($"{START_START_POPULATION} {STEP_START_POPULATION} {END_START_POPULATION}");
            file.WriteLine("START_CROWDING_COEFFICIENT STEP_CROWDING_COEFFICIENT END_CROWDING_COEFFICIENT");
            file.WriteLine($"{START_CROWDING_COEFFICIENT} {STEP_CROWDING_COEFFICIENT} {END_CROWDING_COEFFICIENT}");
            file.WriteLine("START_REPRODUCTION_PROBABILITY STEP_REPRODUCTION_PROBABILITY END_REPRODUCTION_PROBABILITY");
            file.WriteLine($"{START_REPRODUCTION_PROBABILITY} {STEP_REPRODUCTION_PROBABILITY} {END_REPRODUCTION_PROBABILITY}");
            file.Write($"START_POPULATION CROWDING_COEFFICIENT REPRODUCTION_PROBABILITY DEATH_PROBABILITY {String.Join(" ", Enumerable.Range(1, ITERATIONS) )}");
            foreach (var item in results)
            {
                file.WriteLine();
                file.Write(item);
            }
            file.Close();
        }

        //Run multiple simulations
        static void MultipleSimulations(List<int> startPopulations, List<double> crowdingCoefficients, List<double> reproductionProbabilities, List<double> deathProbabilities, string[,,] results)
        {
            //For each combination of parameters
            for(int i = 0; i < startPopulations.Count; i++)
            {
                int startPopulation = startPopulations[i];
                for (int y = 0; y < crowdingCoefficients.Count; y++)
                {
                    double crowdingCoefficient = crowdingCoefficients[y];
                    for (int z = 0; z < reproductionProbabilities.Count; z++)
                    {
                        double reproductionProbability = reproductionProbabilities[z];
                        double deathProbability = deathProbabilities[z];
                        //Run the simulation with the given parameters
                        results[i, y, z] = $"{startPopulation} {crowdingCoefficient} {reproductionProbability} {deathProbability} {SingleSimulation(startPopulation, crowdingCoefficient, reproductionProbability, deathProbability)}";
                    }
                }
                Console.Write('-');
            }
        }

        //Run a single simulation
        static string SingleSimulation(int nCreatureStart, double crowdingCoefficient, double reproductionProbability, double deathProbability)
        {
            //Run the simulation multiple times with the same parameters and average the results
            List<int> simulationInfo = new List<int>(Enumerable.Repeat(0, ITERATIONS));
            //Run the simulation multiple times and add the results
            for (int i = 0; i < NSIMULATIONS; i++)
            {
                Simulation sim = new((short)nCreatureStart, reproductionProbability, deathProbability, crowdingCoefficient, Prime.GetNextPrime());

                simulationInfo[0] += (short)nCreatureStart;
                for (int j = 1; j < ITERATIONS; j++)
                    simulationInfo[j] += sim.NextIteration();
            }
            //Average the results
            for (int i = 0; i < simulationInfo.Count; ++i)
                simulationInfo[i] = (int)Math.Round((double)simulationInfo[i] / NSIMULATIONS);

            return String.Join(" ", simulationInfo);
        }
    }
}