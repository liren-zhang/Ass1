import { useEffect, useState } from 'react';

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
  }, [userId]);   // 当 userId 变化时重新获取购物车

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

  if (loading) return <div>Loading...</div>;
  if (!cart || cart.items.length === 0) return <div>Your cart is empty.</div>;

  return (
    <div>
      <h2>Shopping Cart (User {userId})</h2>
      <ul>
        {cart.items.map(item => (
          <li key={item.product.id}>
            {item.product.name} - ${item.product.price} x {item.quantity}
            <input
              type="number"
              min="1"
              value={item.quantity}
              onChange={(e) => updateQuantity(item.product.id, parseInt(e.target.value))}
              style={{ width: '60px', marginLeft: '10px' }}
            />
            <button onClick={() => removeItem(item.product.id)}>Remove</button>
          </li>
        ))}
      </ul>
      <h3>Total: ${cart.total_price}</h3>
    </div>
  );
}

export default Cart;