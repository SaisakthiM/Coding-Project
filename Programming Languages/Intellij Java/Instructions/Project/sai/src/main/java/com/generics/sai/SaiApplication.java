package com.generics.sai;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Stack;
import java.util.TreeMap;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
public class SaiApplication extends Car {

	public static void main(String[] args) {
		SpringApplication.run(SaiApplication.class, args);
		Car int1 = new Car();
		HashMap<String, Integer> map = new HashMap<>(); // breakpoint

		map.put("apple", 1);
		map.put("banana", 2);
		map.put("cherry", 3);
		map.put("Aa", 1);      // breakpoint
		map.put("BB", 2);      // breakpoint — collision happens here!
		map.remove("apple");

        TreeMap<String, Integer> tree = new TreeMap<>();

		tree.put("apple", 1);
		tree.put("banana", 2);
		tree.put("cherry", 3);
		tree.put("Aa", 1);      // breakpoint
		tree.put("BB", 2);      // breakpoint — collision happens here!
		tree.remove("apple");

		LinkedList<Integer> link = new LinkedList<>();
		link.add(1);
		link.add(2);
		link.add(3);
		link.add(4);
		link.remove(1);
		link.pop();
		link.poll();

		HashSet<Integer> set = new HashSet<>();
		set.add(1);
		set.add(2);
		set.add(3);
		set.add(4);
		set.add(2);
		set.remove(1);

		Stack<Integer> stack = new Stack<>();
		stack.add(1);
		stack.add(2);
		stack.add(3);
		stack.add(4);
		stack.remove(1);
		stack.pop();
		System.out.print(stack.peek());

((java.util.HashMap)map).table		
	}

}
