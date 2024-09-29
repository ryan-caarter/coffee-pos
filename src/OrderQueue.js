// src/OrderQueue.js
import React from "react";


const OrderQueue = ({ orders, completeOrder, role }) => {
  return (
    <div>
      {orders.length === 0 ? (
        <p>No orders yet</p>
      ) : (
        orders.map((order, index) => (
          <div className="center" key={index}  style={{ border: "3px solid rgb(74, 111, 74)", padding: "10px", marginBottom: "10px" }} >
            <h2><strong>{order.customerName && index === 0 ? order.customerName + 's up next!' : order.customerName}</strong> </h2>
            <p className="grid-item">Coffee: <br/><strong>{order.coffeeType}</strong></p>
            <p className="grid-item">Milk: <br/><strong>{order.milkType}</strong></p>
            {order.notes && <p className="grid-item">Notes: <br/><strong>{order.notes}</strong></p>}
            {role === "Barista" && (<>
                <p></p> 
                <button className="grid-item" onClick={() => completeOrder(order)}>Complete</button>
              </>
            )
            }
            </div>          
        ))
      )}
    </div>
  );
};

export default OrderQueue;
