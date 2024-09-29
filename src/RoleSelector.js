// src/RoleSelector.js
import React from "react";

const RoleSelector = ({ setRole }) => {

  return (
    <div className="center">
      <h1>Select a Role</h1>
      <button className="option" onClick={() => setRole("Customer")}>User</button>
      <button className="option" onClick={() => setRole("Barista")}>Barista</button>
    </div>
  );
};

export default RoleSelector;
