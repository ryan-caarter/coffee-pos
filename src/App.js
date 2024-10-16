// src/App.js
import React, { useState, useEffect } from "react";
import OrderForm from "./OrderForm";
import OrderQueue from "./OrderQueue";
import RoleSelector from "./RoleSelector";

const webSocket = new WebSocket(`${process.env.WEBSOCKET_ENDPOINT}/${process.env.STAGE}/`);

const App = () => {
  const [orders, setOrders] = useState([]);
  const [role, setRole] = useState("");
  const [name, setName] = useState("");
  const [ws, setWs] = useState(null);

  useEffect(() => {

    setWs(webSocket);
    webSocket.onopen = () => {
        console.log('Connected to WebSocket');
    };
  
    webSocket.onmessage = (event) => {
        const message = JSON.parse(event.data);
        if (message.action === 'newOrder') {
            setOrders((prevOrders) => [...prevOrders, message.order])
        } else if (message.action === 'removeOrder') {
          setOrders((prevOrders) => prevOrders.filter(order => order.orderId !== message.order.orderId));
        }
    };
  
    webSocket.onclose = () => {
        console.log('Disconnected from WebSocket');
    };
  
    webSocket.onerror = (error) => {
        console.error('WebSocket error:', error);
    };
  }, []);
 
  const addOrder = (order) => {
    if (ws && order) {
        const message = {
            action: 'add',
            data: { order }
        };
        console.log(order);
        ws.send(JSON.stringify(message));
      }
  };

  const completeOrder = (order) => {
    if (ws && order) {
      const message = {
          action: 'complete',
          data: { order }
      };
      console.log(order);
      ws.send(JSON.stringify(message));
    }
  };

  return (
    <div className="App center">
      {!role ? (
        <RoleSelector setRole={setRole} setName={setName} />
      ) : (
        <>
          {role === "Customer" && 
          <div className="grind-container">
            <h1 className="grid-item option">
              Welcome to Mongrel Mojo!
            </h1>
          </div>}
          {role === "Customer" && <OrderForm addOrder={addOrder} role={role} name={name}/>}
          <h2>Queue</h2>
          <OrderQueue orders={orders} completeOrder={completeOrder} role={role} />
        </>
      )}
    </div>
  );
};

export default App;
