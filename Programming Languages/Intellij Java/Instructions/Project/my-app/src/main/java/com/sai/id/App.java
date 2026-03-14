package com.sai.id;

import javax.management.timer.Timer;

/**
 * Hello world!
 *
 */
public class App extends Ford implements Main, Car<String>, Bike {
  public int main() {
    return 5;
  }

  public Integer car() {
    return 6;
  }

  public String Model() {
    return "hi";
  }

  public void main(String[] args) {
    System.out.print(Integer.toString(main()) + "\n");
    System.out.print(Integer.toString(car()) + "\n");
    System.out.print(true);
    Ford ford = new Ford();
    try {
      // Ford ford = new Ford(); // Duplicate variable declaration - removed
      Ford ford1 = (Ford) ford.clone(); // Need to cast clone() result
      System.out.print(ford1.Model("naisd"));
    } catch (CloneNotSupportedException e) { // Must specify exception type
      System.out.print("\n ok it did not work");
    } finally {
      int x = 10;
      System.out.println(x);
    }
  }
}
