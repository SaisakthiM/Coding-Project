import style from "./Header.module.css";

export default function Header() {
    return (
        <header>
            <h1 className={style.header}>Tic Tac Toe</h1>
        </header>
    );
}