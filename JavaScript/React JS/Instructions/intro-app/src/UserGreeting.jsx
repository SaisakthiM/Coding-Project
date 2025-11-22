import PropTypes from 'prop-types';

function UserGreeeting({ isLoggedIn = true, username = "Guest" }) {
  const welcomePrompt = <h2 className="welcome-class">Welcome {username}</h2>;
  const loginPrompt = <h2 className="login-prompt">Please log in</h2>;

  return isLoggedIn ? welcomePrompt : loginPrompt;
}

// Correct propTypes
UserGreeeting.propTypes = {
    user: PropTypes.shape({
    isLoggedIn: PropTypes.bool,
    username: PropTypes.string,
  }),
};

export default UserGreeeting

