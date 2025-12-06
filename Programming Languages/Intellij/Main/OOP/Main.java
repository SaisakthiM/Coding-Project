public class Main {
    public static void main(String[] args) {
        Student Kinal;
        Kinal = new Student();
        System.out.print(Kinal.k());
    }
    public class Student {
        int rno;
        String name;
        float mark;

        void greet() {
            System.out.print("Hello my name is", name);
        }
        void special() {
            String name2 = "sai";
        }
        void k() {
            System.out.print(name2);
        }
    }
}
