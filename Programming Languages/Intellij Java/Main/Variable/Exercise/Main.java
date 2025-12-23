import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> colors = new ArrayList<>();
        colors.add("blue");
        colors.add("red");
        colors.add("green");
        colors.add("main");
        System.out.println(colors);

        for (String color : colors) {
            System.out.println(color);
        }
        
    }
}
