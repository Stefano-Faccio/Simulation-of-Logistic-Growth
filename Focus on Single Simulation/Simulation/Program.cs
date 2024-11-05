using System.Globalization;
using System;
using System.Collections;
using System.Linq;

namespace LogisticSimulation
{
    internal class Program
    {
        //Simulation settings parameters
        const int START_POPULATION = 51;
        const double CROWDING_COEFFICIENT = 0.00001;
        const double REPRODUCTION_PROBABILITY = 0.1;
        const double DEATH_PROBABILITY = 0.05;
        static int NSIMULATIONS = 1000;
        static int ITERATIONS = 500;

        static void Main(string[] args)
        {
            //Initial setup
            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture; // Decimal numbers are printed with dot and not comma
            string path_data = "data.txt";
            string path_header = "header.txt";

            //----------------------//

            //Run the simulations
            string[] results = MultipleSimulations();

            //----------------------//

            //Write the results to file
            File.Delete(path_header);
            File.Delete(path_data);

            StreamWriter file_header = File.AppendText(path_header);
            StreamWriter file_data = File.AppendText(path_data);

            file_header.WriteLine("NSIMULATIONS ITERATIONS START_POPULATION CROWDING_COEFFICIENT REPRODUCTION_PROBABILITY DEATH_PROBABILITY");
            file_header.Write($"{NSIMULATIONS} {ITERATIONS+1} {START_POPULATION} {CROWDING_COEFFICIENT} {REPRODUCTION_PROBABILITY} {DEATH_PROBABILITY}");
            file_header.Close();

            foreach (var item in results)
                file_data.WriteLine(item);

            file_data.Close();
        }

        //Multiple runs of the simulation
        static string[] MultipleSimulations()
        {
            string[] _results = new string[NSIMULATIONS];
            List<short> simulationInfo = new(new short[ITERATIONS + 1]);

            //For each simulation run
            for (int i = 0; i < NSIMULATIONS; i++)
            {
                //New simulation instance with next seed
                Simulation sim = new(START_POPULATION, REPRODUCTION_PROBABILITY, DEATH_PROBABILITY, CROWDING_COEFFICIENT, Prime.GetNextPrime());
                //Execute the simulation
                simulationInfo[0] = START_POPULATION;
                for (int j = 1; j < ITERATIONS + 1; j++)
                    simulationInfo[j] = sim.NextIteration();
                //Save the results
                _results[i] = String.Join(" ", simulationInfo);
            }
    
            Console.WriteLine("Done");
            return _results;
        }
    }
}