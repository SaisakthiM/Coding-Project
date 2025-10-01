import React from 'react';
import { useAuth } from '../../hooks/useAuth';

const Profile = () => {
    const { user, updateUser } = useAuth();

    const handleUpdate = (event) => {
        event.preventDefault();
        // Logic to update user profile
        const updatedUser = {
            // Gather updated user data from form inputs
        };
        updateUser(updatedUser);
    };

    return (
        <div className="profile">
            <h1>{user.name}'s Profile</h1>
            <form onSubmit={handleUpdate}>
                <div>
                    <label htmlFor="name">Name:</label>
                    <input type="text" id="name" defaultValue={user.name} />
                </div>
                <div>
                    <label htmlFor="email">Email:</label>
                    <input type="email" id="email" defaultValue={user.email} />
                </div>
                <button type="submit">Update Profile</button>
            </form>
        </div>
    );
};

export default Profile;