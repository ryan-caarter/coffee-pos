// src/OrderForm.js
import React, { useState } from "react";

const coffeeOptions = ["Tea", "Espresso", "Americano", "Flat White", "Iced Latte", "Iced Chocolate"];
const pastryOptions = ["Hot Cross Bun", "Cupcake", "Almond Croissant", "Carrot Cake"];

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
      <h3>From the kitchen</h3>
      {pastryOptions.map((pastry) => (
        <button className="grid-item" style={{padding: 10, margin: 10}} key={pastry} onClick={() => setSelectedPastry(pastry)}>
          {pastry}
        </button>
      ))}
      {selectedPastry && (
        <>
        <h4>{selectedPastry}</h4>
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
            <h4>{selectedCoffee}</h4>
            <select className="option" name="milkType" onChange={(e) => setMilkType(e.target.value)}>
              <option value="Oat">Oat Milk</option>
              <option value="Regular">Regular Milk</option>
              <option value="None">None</option>
            </select>
            <br></br>
            <br></br>
            <button className="remove" onClick={() => {setSelectedCoffee(""); setMilkType("");}}>Remove</button>
        </>
      )}

      {(selectedPastry || selectedCoffee) && 
      <>
      <p style={{ fontSize: '10px' }}><i>All items are to be paid by acquistion of an undesirable item in the garage. <br></br>
      Items are non-refundable. Coffee mugs used are also owned by the user after use. <br></br>
      By submitting an order to this service you hereby agree to these terms.</i></p>
      <br></br>
      {/* <br></br> */}
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
        placeholder="Tea type, extra notes, dietary requirements etc."
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
