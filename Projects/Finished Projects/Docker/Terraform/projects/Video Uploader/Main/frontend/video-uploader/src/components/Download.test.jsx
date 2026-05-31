// Download.test.jsx
import { render, screen, waitFor } from '@testing-library/react';
import { describe, test, expect, vi } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import Download, { Comments } from '../Download';

vi.mock('../Getter', () => ({
    default: vi.fn(() => Promise.resolve({ data: ['video1.mp4', 'video2.mp4'] }))
}));

describe('Download Component', () => {

    test('shows loading state initially', () => {
        render(<MemoryRouter><Download /></MemoryRouter>);
        expect(screen.getByText('Loading videos...')).toBeInTheDocument();
    });

    test('renders download heading', () => {
        render(<MemoryRouter><Download /></MemoryRouter>);
        expect(screen.getByText('Download Videos')).toBeInTheDocument();
    });
});

describe('Comments Component', () => {

    test('renders file list with download links', async () => {
        const mockData = Promise.resolve({ data: ['video1.mp4', 'video2.mp4'] });
        render(<MemoryRouter><Comments data={mockData} /></MemoryRouter>);

        await waitFor(() => {
            expect(screen.getByText('video1.mp4')).toBeInTheDocument();
            expect(screen.getByText('video2.mp4')).toBeInTheDocument();
        });
    });

    test('download links have correct href', async () => {
        const mockData = Promise.resolve({ data: ['video1.mp4'] });
        render(<MemoryRouter><Comments data={mockData} /></MemoryRouter>);

        await waitFor(() => {
            const link = screen.getByText('video1.mp4').closest('a');
            expect(link).toHaveAttribute('href', '/video/api/download/video1.mp4');
            expect(link).toHaveAttribute('download', 'video1.mp4');
        });
    });
});