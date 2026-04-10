import { useEffect, useState } from 'react';
import Cart from './Cart';
import './App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [showCart, setShowCart] = useState(false);
  const [userId, setUserId] = useState(1);

  useEffect(() => {
    fetch('/api/products/')
      .then(res => res.json())
      .then(data => setProducts(data))
      .catch(err => console.error(err));
  }, []);

  const addToCart = (productId) => {
    fetch(`/api/cart/add/?user_id=${userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ product_id: productId, quantity: 1 })
    })
      .then(() => alert('Added to cart!'))
      .catch(err => console.error(err));
  };

  return (
    <div className="app-container">
      <div className="navbar">
        <button
          className={`nav-btn ${!showCart ? 'active' : ''}`}
          onClick={() => setShowCart(false)}
        >
          Products
        </button>
        <button
          className={`nav-btn ${showCart ? 'active' : ''}`}
          onClick={() => setShowCart(true)}
        >
          Cart
        </button>
        <select
          className="user-select"
          value={userId}
          onChange={(e) => setUserId(parseInt(e.target.value))}
        >
          <option value="1">User 1 (admin)</option>
          <option value="2">User 2</option>
          <option value="3">User 3</option>
        </select>
      </div>
      <div className="content">
        {showCart ? (
          <Cart userId={userId} />
        ) : (
          <>
            <h1 className="page-title">Products</h1>
            <div className="products-grid">
              {products.map(p => (
                <div key={p.id} className="product-card">
                  <div className="product-name">{p.name}</div>
                  <div className="product-price">${p.price}</div>
                  <button className="add-btn" onClick={() => addToCart(p.id)}>Add to Cart</button>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
}

export default App;