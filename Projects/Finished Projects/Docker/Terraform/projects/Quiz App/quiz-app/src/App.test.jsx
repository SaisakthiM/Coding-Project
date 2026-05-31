// App.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, test, expect, vi } from 'vitest';
import App from './App';
vi.mock('*.css', () => ({}));
vi.mock('**/*.css', () => ({}));

// Mock alert since jsdom doesn't support it
global.alert = vi.fn();

describe('App Component', () => {

    test('shows header before quiz starts', () => {
        render(<App />);
        expect(screen.getByText('Ready for the journey?')).toBeInTheDocument();
    });

    test('clicking start shows first question', () => {
        render(<App />);
        fireEvent.click(screen.getByText('Start'));
        expect(screen.getByText('What is 2 + 2?')).toBeInTheDocument();
    });

    test('clicking next without selecting shows alert', () => {
        render(<App />);
        fireEvent.click(screen.getByText('Start'));
        fireEvent.click(screen.getByText('Next'));
        expect(global.alert).toHaveBeenCalledWith('Please choose an option!');
    });

    test('correct answer increments score', () => {
        render(<App />);
        fireEvent.click(screen.getByText('Start'));

        // Answer all 5 questions correctly
        const correctAnswers = ['4', 'JavaScript', 'Markup Language', 'Library', 'Cascading Style Sheets'];
        correctAnswers.forEach(answer => {
            fireEvent.click(screen.getByText(answer));
            fireEvent.click(screen.getByText('Next'));
        });

        expect(screen.getByText(/5 \/ 5/i)).toBeInTheDocument();
    });

    test('shows score page after all questions answered', async () => {
        render(<App />);
        fireEvent.click(screen.getByText('Start'));

        for (let i = 0; i < 5; i++) {
            const options = screen.getAllByRole('listitem');
            fireEvent.click(options[0]);          // select any option
            fireEvent.click(screen.getByText('Next'));
        }

        expect(screen.getByText('Quiz Completed!')).toBeInTheDocument();
    });

    test('wrong answers result in score 0', () => {
        render(<App />);
        fireEvent.click(screen.getByText('Start'));

        // Pick last option — wrong for all 5 questions (answers are 3,1,1,0,0)
        for (let i = 0; i < 5; i++) {
            const options = screen.getAllByRole('listitem');
            fireEvent.click(options[options.length - 1]);
            fireEvent.click(screen.getByText('Next'));
        }

        // Score is split across elements: "Your Score: ", "0", " / ", "5"
        expect(screen.getByText((_, el) =>
            el?.tagName === 'H2' && el.textContent.replace(/\s+/g, ' ').trim() === 'Your Score: 0 / 5'
        )).toBeInTheDocument();
    });
});