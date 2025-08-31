
using System;using System.ComponentModel;
using System.Dynamic;

static void for_int()
{
    int k = 10;
    double y = 2.1;
    bool o = true;
    char q = 'i';
    string e = "hi";
    var list = new List<dynamic>() { k, y, o, q, e };
    foreach (dynamic x in list)
    {
        Console.WriteLine(x);
    }
    double k = 2.182939619791370818F;
    Console.WriteLine(k);
    int k = 192;
    double u = k;
    Console.WriteLine(u);
    int k = 10;
    long u = Convert.ToInt64(k);
    int[] k = { 1, 2, 3, 4, 5 };
    foreach (int x in k)
    {
        Console.WriteLine(x);//This prints each element one by one start to finish
    }
    int[,] k = {{1,2}, {3,4}};
    Console.Write(k[0,0]) //{The first index mentions 0th element and second tells 0th element of that element}

}

static void for_str() {
    Console.Write("Enter Username : ");
    string res;
    res = Console.ReadLine();

    Console.WriteLine("Hi, "+res);Console.Write("Enter a Number : ");
    int k = Convert.ToInt32(Console.ReadLine());
    Console.WriteLine("Your Number is : " + Convert.ToString(k));

    Console.WriteLine(Math.Max(15,10));
    Console.WriteLine(Math.Min(15,10));
    Console.WriteLine(Math.Abs(-10));
    Console.WriteLine(Math.Round(9.54));

    //String Concatenation :
    string first_name = "sai";
    string last_name = "sakthi";
    string full_name = first_name + " " + last_name;
    Console.WriteLine(full_name);

    // There is also a String Function to add two string. that is string.concat(str1, str2)
    string full_name = string.Concat("sai","sakthi");
    COnsole.WriteLine(full_name);

    //We can also access string using indexes.
    //for eg : string first_name = "sai";
    Console.WriteLine(first_name[0]);
}

static void greet(){
    Console.Write("Enter a Day : ");
    string res = Console.ReadLine();
    switch (res)
    {
        case "Monday":
            Console.WriteLine("You entered Monday.");
            break;
        case "Tuesday":
            Console.WriteLine("You Entered Tuesday");
            break;
        case "Wednesday":
            Console.WriteLine("You Entered Wednesday");
            break;
        case "Thursday":
            Console.WriteLine("You Entered Thursday");
            break;
        case "Friday":
            Console.WriteLine("You Entered Friday");
            break;
        case "Saturday":
            Console.WriteLine("You Entered Saturday");
            break;
        case "Sunday":
            Console.WriteLine("You Entered Sunday");
            break;
        default:
            Console.WriteLine("You Entered Wrong option");
            break;
    }
}













































