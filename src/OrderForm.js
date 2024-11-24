// src/OrderForm.js
import React, { useState } from "react";

const coffeeOptions = ["Espresso", "Latte", "Cappuccino", "Americano", "Flat White", "Iced Latte", "Iced Chocolate", "Hot Chocolate"];
const pastryOptions = ["Croissant", "Caramel Slice", "Crookie", "Muffin"];

const OrderForm = ({ addOrder }) => {
  const [selectedCoffee, setSelectedCoffee] = useState("");
  const [customerName, setCustomerName] = useState("");
  const [milkType, setMilkType] = useState("Oat");
  const [pastry, setPastry] = useState(null)
  const [extraNotes, setExtraNotes] = useState("");
  
  const handleSubmit = () => {
    if (!selectedCoffee) {
      alert("Bruh please select a coffee type");
      return;
    }

    if (!customerName) {
      alert("Cmon, enter a name, tf");
      return;
    }

    const order = {
      coffee: selectedCoffee,
      customerName: customerName.toUpperCase(),
      pastry,
      milkType,
      extraNotes,
    };
    addOrder(order);
    setSelectedCoffee("");
    setPastry(null)
    setCustomerName("");
    setMilkType("");
    setExtraNotes("");
  };

  return (
    <div style={{ border: "8px solid rgb(74, 111, 74)", padding: "10px", marginBottom: "10px" }}>
      <h2>Place an Order</h2>
      <h3>From the bakery</h3>
      {pastryOptions.map((pastry) => (
        <button className="grid-item" style={{padding: 10, margin: 20}} key={pastry} onClick={() => setPastry(pastry)}>
          {pastry}
        </button>
      ))}
      {pastry && (
        <h4>Selected: {pastry}</h4>
      )}
      <hr style={{ border: 'none', height: '5px', backgroundColor: 'rgb(74, 111, 74)' }}></hr>
      <h3>To drink</h3>
      {coffeeOptions.map((coffee) => (
        <button className="grid-item" style={{padding: 10, margin: 20}} key={coffee} onClick={() => setSelectedCoffee(coffee)}>
          {coffee}
        </button>
      ))}
      
      
      {selectedCoffee && (
        <div>
            <h4>{selectedCoffee}</h4>
            <select className="option" name="milkType" onChange={(e) => setMilkType(e.target.value)}>
              <option value="Oat">Oat Milk</option>
              <option value="Coconut">Coconut Milk</option>
              <option value="Soy">Soy Milk</option>
              <option value="Regular">Regular Milk</option>
            </select>
            <br></br>
            <br></br>
            <input
            className="option"
              type="text"
              placeholder="Your name"
              value={customerName}
              onChange={(e) => setCustomerName(e.target.value)}
            />
            <br></br>
            <br></br>
            <input
              className="option"
              type="text"
              placeholder="Extra notes, dietary requirements"
              value={extraNotes}
              onChange={(e) => setExtraNotes(e.target.value)}
            />
            <br></br>
            <br></br>
            <button className="option" onClick={handleSubmit}>Submit Order</button>

        </div>
      )}
    </div>
  );
};

export default OrderForm;
