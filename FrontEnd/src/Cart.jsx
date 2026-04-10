import { useEffect, useState } from 'react';
import './App.css';

function Cart({ userId }) {
  const [cart, setCart] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchCart = () => {
    fetch(`/api/cart/my_cart/?user_id=${userId}`)
      .then(res => res.json())
      .then(data => {
        setCart(data);
        setLoading(false);
      })
      .catch(err => console.error(err));
  };

  useEffect(() => {
    fetchCart();
  }, [userId]);

  const updateQuantity = (productId, newQuantity) => {
    fetch(`/api/cart/update_quantity/?user_id=${userId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ product_id: productId, quantity: newQuantity })
    })
      .then(() => fetchCart())
      .catch(err => console.error(err));
  };

  const removeItem = (productId) => {
    fetch(`/api/cart/remove/?user_id=${userId}`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ product_id: productId })
    })
      .then(() => fetchCart())
      .catch(err => console.error(err));
  };

  if (loading) return <div className="empty-cart">Loading...</div>;
  if (!cart || cart.items.length === 0) return <div className="empty-cart">Your cart is empty.</div>;

  return (
    <div>
      <div className="cart-header">
        <h1 className="page-title">Shopping Cart (User {userId})</h1>
      </div>
      <ul className="cart-items">
        {cart.items.map(item => (
          <li key={item.product.id} className="cart-item">
            <div className="item-info">
              <div className="item-name">{item.product.name}</div>
              <div className="item-price">${item.product.price} each</div>
            </div>
            <div className="item-controls">
              <input
                type="number"
                min="1"
                value={item.quantity}
                onChange={(e) => updateQuantity(item.product.id, parseInt(e.target.value))}
                className="quantity-input"
              />
              <button className="remove-btn" onClick={() => removeItem(item.product.id)}>Remove</button>
            </div>
          </li>
        ))}
      </ul>
      <div className="cart-total">Total: ${cart.total_price}</div>
    </div>
  );
}

export default Cart;