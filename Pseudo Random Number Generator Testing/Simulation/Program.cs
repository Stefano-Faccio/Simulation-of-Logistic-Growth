using MathNet.Numerics.Random;
using System;
using System.Globalization;

namespace MersenneTwistertest
{
    internal class Program
    {
        static string path = "data.txt";
        static int NSEED = 100;
        static int NSAMPLE = 100000;
        static void Main(string[] args)
        {
            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
            //Check the parameters from the command line
            if(args.Length == 2 && Int32.TryParse(args[0], out int nseed) && Int32.TryParse(args[1], out int nsampe)) 
            {
                NSEED = nseed;
                NSAMPLE = nsampe;

                Console.WriteLine($"N of seeds: {NSEED}, N of samples: {NSAMPLE}");
            }

            //Delete the file if it exists and create a new one to write the data
            File.Delete(path);
            StreamWriter file = File.AppendText(path);
            
            //Lists of seeds and samples
            List<int> seeds = new(NSEED);
            List<Double[]> samples = new(NSEED);

            //Sample the data
            for (int i = 0; i < NSEED; i++)
            {
                //Get next seed
                seeds.Add(Prime.GetNextPrime());
                //New instance of the MersenneTwister with the new seed
                MersenneTwister mst = new(seeds[i]);
                //Get all the samples
                samples.Add(mst.NextDoubles(NSAMPLE));
                //Just for the user to know that the program is working
                Console.Write(".");
            }

            //Write the data to the file
            //First the seeds
            file.WriteLine(string.Join(" ", seeds));
            for (int i = 0; i < NSAMPLE; i++)
            {
                string str = "";
                for(int u = 0; u < NSEED; u++)
                {
                    str += $"{samples[u][i]} ";
                }
                file.WriteLine(str);
                //Just for the user to know that the program is working
                Console.Write("-");
            }

            file.Close();
        }
    }
}