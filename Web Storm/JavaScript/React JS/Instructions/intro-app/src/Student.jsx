import React, { Component } from "react";
import PropTypes from "prop-types";

class Student extends Component {
  render() {
    const { name, age, isStudent } = this.props;
    return (
      <div className="student">
        <p>Name: {name}</p>
        <p>Age: {age}</p>
        <p>Student: {isStudent ? "Yes" : "No"}</p>
      </div>
    );
  }
}

// Type checking
Student.propTypes = {
  name: PropTypes.string,
  age: PropTypes.number,
  isStudent: PropTypes.bool,
};

// Default values for props
Student.defaultProps = {
  name: "Guest",
  age: 0,
  isStudent: false,
};

export default Student;
