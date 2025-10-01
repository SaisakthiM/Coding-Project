import React from 'react';
import { Card, CardContent, Typography } from '@mui/material';

const Post = ({ post }) => {
    return (
        <Card>
            <CardContent>
                <Typography variant="h5" component="div">
                    {post.title}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                    {post.content}
                </Typography>
                <Typography variant="caption" color="text.secondary">
                    Posted by: {post.author}
                </Typography>
            </CardContent>
        </Card>
    );
};

export default Post;