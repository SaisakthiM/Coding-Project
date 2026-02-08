package com.sai.id;

/**
 * Hello world!
 *
 */
public class App implements Main, Car<Integer> {
  public int main() {
    return 5;
  }

  public Integer car() {
    return 6;
  }

  public void Model() {
    System.out.print("This is Ford");
  }

  public void main(String[] args) {
    System.out.print(Integer.toString(main()) + "\n");
    System.out.print(Integer.toString(car()) + "\n");
    Model();
  }
}
