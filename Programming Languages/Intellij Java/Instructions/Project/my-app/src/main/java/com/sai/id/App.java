package com.sai.id;

/**
 * Hello world!
 *
 */
public class App implements Main, Car<Integer>, Bike {
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
  }
}
