// src/RoleSelector.js
import React, { useState } from "react";

const RoleSelector = ({ setRole, role }) => {
  const [unvalidatedBarista, setUnvalidatedBarista] = useState(false);
  const [passwordAttempt, setPasswordAttempt] = useState("");

  const handleSubmitPassword = () => {
    if (passwordAttempt === "1314888*") {
      setRole("Barista");
    } 
    else {
      alert("Wrong password. Very sus")
    }
    setPasswordAttempt("")
  }
  return (
    <>
    <div className="center">
      <h1>Select a Role</h1>
      <button className="option" onClick={() => setRole("Customer")}>User</button>
      <button className="option" onClick={() => setUnvalidatedBarista(true)}>Barista</button>
    {unvalidatedBarista &&
      <div>
        <br></br>
        <input
          className="option"
          type="password"
          placeholder="Enter password"
          value={passwordAttempt}
          onChange={(e) => setPasswordAttempt(e.target.value)}
        />
        <br></br>
        <br></br>
        <button 
          className="option" 
          variant="primary" 
          onClick={(e) => handleSubmitPassword(e.target.value)}
          >
            Submit
        </button>
      </div>
    }
    </div>
    </>
  );
};

export default RoleSelector;
