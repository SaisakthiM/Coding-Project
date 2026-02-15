package com.sai.id;

public class Ford implements Car<String>, Cloneable {
  public String Model(String main) {
    return main;
  };

  public Ford clone() throws CloneNotSupportedException {
    return (Ford) super.clone();
  }

}
