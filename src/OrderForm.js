// src/OrderForm.js
import React, { useState } from "react";

const coffeeOptions = ["Espresso", "Latte", "Cappuccino", "Americano", "Flat White", "Iced Latte", "Iced Chocolate", "Hot Chocolate"];
const pastryOptions = ["Croissant", "Caramel Slice", "Crookie", "Blueberry Muffin"];

const OrderForm = ({ addOrder }) => {
  const [selectedCoffee, setSelectedCoffee] = useState("");
  const [customerName, setCustomerName] = useState("");
  const [milkType, setMilkType] = useState("");
  const [selectedPastry, setSelectedPastry] = useState(null)
  const [extraNotes, setExtraNotes] = useState("");
  
  const handleSubmit = () => {
    if (!selectedCoffee && !selectedPastry) {
      alert("Bruh please select something to eat");
      return;
    }

    if (!customerName) {
      alert("Cmon, enter a name, tf");
      return;
    }

    const order = {
      coffee: selectedCoffee,
      customerName: customerName.toUpperCase(),
      pastry: selectedPastry,
      milkType,
      extraNotes,
    };
    addOrder(order);
    setSelectedCoffee("");
    setSelectedPastry(null)
    setCustomerName("");
    setMilkType("");
    setExtraNotes("");
  };

  return (
    <div style={{ border: "8px solid rgb(74, 111, 74)", padding: "10px", marginBottom: "10px" }}>
      <h2>Place an Order</h2>
      <h3>From the bakery</h3>
      {pastryOptions.map((pastry) => (
        <button className="grid-item" style={{padding: 10, margin: 10}} key={pastry} onClick={() => setSelectedPastry(pastry)}>
          {pastry}
        </button>
      ))}
      {selectedPastry && (
        <>
        <h4>{selectedPastry}{"        "}</h4>
        <button className="remove" onClick={() => setSelectedPastry("")}>Remove</button>
        
        </>
      )}
      <hr style={{ border: 'none', height: '5px', backgroundColor: 'rgb(74, 111, 74)' }}></hr>
      <h3>To drink</h3>
      {coffeeOptions.map((coffee) => (
        <button className="grid-item" style={{padding: 10, margin: 10}} key={coffee} onClick={() => setSelectedCoffee(coffee)}>
          {coffee}
        </button>
      ))}
      {selectedCoffee && (
        <>
            <h4>{selectedCoffee}{"        "}</h4>
            <select className="option" name="milkType" onChange={(e) => setMilkType(e.target.value)}>
              <option value="Oat">Oat Milk</option>
              <option value="Coconut">Coconut Milk</option>
              <option value="Soy">Soy Milk</option>
              <option value="Regular">Regular Milk</option>
            </select>
            <br></br>
            <br></br>
            <button className="remove" onClick={() => setSelectedCoffee("")}>Remove</button>
        </>
      )}

      {(selectedPastry || selectedCoffee) && 
      <>
      <br></br>
      <br></br>
      <hr style={{ border: 'none', height: '5px', backgroundColor: 'rgb(74, 111, 74)' }}></hr> 

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
      <br></br>
      <br></br>
      </>
    }
    </div>
  );
};

export default OrderForm;
