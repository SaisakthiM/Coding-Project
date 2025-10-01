import React from 'react';
import { Link } from 'react-router-dom';
import { List, ListItem, ListItemText } from '@mui/material';

const Sidebar = () => {
    return (
        <div>
            <List>
                <ListItem button component={Link} to="/">
                    <ListItemText primary="Home" />
                </ListItem>
                <ListItem button component={Link} to="/profile">
                    <ListItemText primary="Profile" />
                </ListItem>
                <ListItem button component={Link} to="/login">
                    <ListItemText primary="Login" />
                </ListItem>
                <ListItem button component={Link} to="/register">
                    <ListItemText primary="Register" />
                </ListItem>
            </List>
        </div>
    );
};

export default Sidebar;