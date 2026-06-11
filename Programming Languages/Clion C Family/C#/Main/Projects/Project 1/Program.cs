using System;
using System.Linq;
using System.Reflection.Metadata;
namespace MyFirstProgram
{

class Program
    {
        static void Main(String[] args)
        {
            // while (true)
            // {
            //     String res;
            //     Console.WriteLine("This is a number guessing game. ");
            //     Console.Write("Do You want to start (y/n) : ");
            //     res = Console.ReadLine();

            //     if (res == "y" || res == "yes")
            //     {
            //         Random random = new Random();
            //         int number = random.Next(1,10);
            //         int input;
            //         Console.WriteLine("This is a number guessing game");
            //         Console.Write("Enter a number between 1 to 10 : ");
            //         input = Convert.ToInt32(Console.ReadLine());
            //         if (number == input)
            //         {
            //             Console.WriteLine("Yes, you guessed the number.");
            //         }
            //         else
            //         {
            //             Console.WriteLine("Wrong Guess");
            //             Console.WriteLine("Your Guess : " + input);
            //             Console.WriteLine("Computer Guess : " + number);
            //         }
            //     }
            //     else
            //     {
            //         break;
            //     }
                
            // }

            try
            {
                int x; 
                int y;
                Console.Write("Enter Number 1 : ");
                x = Convert.ToInt32(Console.ReadLine());
                Console.Write("Enter Number 2 : ");
                y = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Result" + x/y);

            }

            catch (DivideByZeroException e)
            {
                Console.WriteLine("Tried to divide by zero" );
                Console.WriteLine(e);
            }
            catch (System.FormatException f)
            {
                Console.WriteLine("Failed to convert variable" );
                Console.WriteLine(f);
            }

            
        }
    }

}



























