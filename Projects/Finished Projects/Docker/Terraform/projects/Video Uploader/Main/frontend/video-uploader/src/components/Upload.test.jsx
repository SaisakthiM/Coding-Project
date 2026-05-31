// Upload.test.jsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { describe, test, expect, vi, beforeEach } from 'vitest';
import Upload from '../Upload';

global.fetch = vi.fn();

describe('Upload Component', () => {

    beforeEach(() => {
        vi.clearAllMocks();
    });

    test('renders upload form', () => {
        render(<Upload />);
        expect(screen.getByText('Select image to upload:')).toBeInTheDocument();
        expect(screen.getByRole('button', { name: /upload image/i })).toBeInTheDocument();
    });

    test('file input accepts images only', () => {
        render(<Upload />);
        const input = document.querySelector('#image-upload');
        expect(input).toHaveAttribute('accept', 'image/*');
    });

    test('shows uploading state while request is pending', async () => {
        global.fetch.mockReturnValue(new Promise(() => {}));
        render(<Upload />);

        const file = new File(['dummy'], 'test.jpg', { type: 'image/jpeg' });
        const input = document.querySelector('#image-upload');
        fireEvent.change(input, { target: { files: [file] } });

        fireEvent.submit(document.querySelector('#form'));

        await waitFor(() => {
            expect(screen.getByText('Uploading...')).toBeInTheDocument();
        });
    });

    test('shows success message after upload', async () => {
        global.fetch.mockResolvedValue({
            text: () => Promise.resolve('File Uploaded Successfully!')
        });

        render(<Upload />);
        fireEvent.submit(document.querySelector('#form'));

        await waitFor(() => {
            expect(screen.getByText('File Uploaded Successfully!')).toBeInTheDocument();
        });
    });

    test('shows error message when upload fails', async () => {
        global.fetch.mockRejectedValue(new Error('Network error'));

        render(<Upload />);
        fireEvent.submit(document.querySelector('#form'));

        await waitFor(() => {
            expect(screen.getByText(/Upload failed/)).toBeInTheDocument();
        });
    });

    test('submit button is disabled while uploading', async () => {
        global.fetch.mockReturnValue(new Promise(() => {}));
        render(<Upload />);

        fireEvent.submit(document.querySelector('#form'));

        await waitFor(() => {
            expect(screen.getByRole('button', { name: /upload image/i })).toBeDisabled();
        });
    });
});