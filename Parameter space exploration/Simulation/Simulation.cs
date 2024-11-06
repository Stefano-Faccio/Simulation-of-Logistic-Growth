using MathNet.Numerics.Random;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LogisticSimulation
{
    internal class Simulation
    {
        readonly MersenneTwister mersenneTwister;
        double creatureCounter;
        readonly double crowdingCoefficient;
        readonly double deathProbability;
        readonly double reproductionProbability;

        public Simulation(short nCreatureStart, double reproductionProbability, double deathProbability, 
            double crowdingCoefficient, int seed)
        {
            // PRNG initialization
            mersenneTwister = new MersenneTwister(seed);

            //Parameters initialization
            this.creatureCounter = nCreatureStart;
            this.reproductionProbability = reproductionProbability;
            this.deathProbability = deathProbability;
            this.crowdingCoefficient = crowdingCoefficient;
        }

        //Main events of the simulation
        public short NextIteration()
        {
            //If there are creatures
            if(creatureCounter > 0)
            {
                //Keep track of the change in the number of creatures
                short deltaCreature = 0;
                //Sample the list of random numbers => 2 * creatureCounter (one for reproduction and one for death)
                double[] probabilities = mersenneTwister.NextDoubles(2 * (short)creatureCounter);
                //Rejection sampling
                for (int i = 0; i < creatureCounter; ++i)
                {
                    //(i << 1) is equivalent to (i * 2) but faster
                    if (probabilities[(i << 1)] < reproductionProbability)
                        ++deltaCreature;

                    if (probabilities[(i << 1) + 1] < deathProbability + (crowdingCoefficient * creatureCounter))
                        --deltaCreature;
                }

                //Update creature counter
                creatureCounter += deltaCreature;
            }

            return (short)creatureCounter;
        }

        //Not used
        public short NextTeoricIteration()
        {
            creatureCounter += (reproductionProbability - deathProbability - (crowdingCoefficient * creatureCounter)) * creatureCounter;
            return (short)Math.Round(creatureCounter);
        }
    }
}