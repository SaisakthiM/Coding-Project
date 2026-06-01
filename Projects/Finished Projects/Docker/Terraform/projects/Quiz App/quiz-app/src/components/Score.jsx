import styles from './score.module.css';

export default function Score({ score, total }) {
  return (
    <div className={styles.container}>
      <h1>Quiz Completed!</h1>
      <hr />
      <h2>Your Score: {score} / {total}</h2>
      <p>{score === total ? "Perfect! 🎉" : "Good try! Keep learning!"}</p>
    </div>
  )
}
