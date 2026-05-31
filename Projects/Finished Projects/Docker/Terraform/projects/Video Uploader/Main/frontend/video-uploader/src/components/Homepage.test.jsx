// HomePage.test.jsx
import { render, screen } from '@testing-library/react';
import { describe, test, expect } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import HomePage from '../HomePage';

describe('HomePage', () => {

    test('renders file uploader heading', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('File Uploader')).toBeInTheDocument();
    });

    test('renders upload link', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('Upload a File')).toBeInTheDocument();
    });

    test('renders download link', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('Download or retrieve a File')).toBeInTheDocument();
    });

    test('renders remove link', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('Remove a File')).toBeInTheDocument();
    });

    test('upload link points to /upload', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('Upload a File').closest('a')).toHaveAttribute('href', '/upload');
    });

    test('download link points to /download', () => {
        render(<MemoryRouter><HomePage /></MemoryRouter>);
        expect(screen.getByText('Download or retrieve a File').closest('a')).toHaveAttribute('href', '/download');
    });
});