import { useEffect, useState } from 'react';
import Cart from './Cart';

function App() {
  const [products, setProducts] = useState([]);
  const [showCart, setShowCart] = useState(false);
  const [userId, setUserId] = useState(1);   // 当前用户 ID，默认为 1 (admin)

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
    <div>
      <nav>
        <button onClick={() => setShowCart(false)}>Products</button>
        <button onClick={() => setShowCart(true)}>Cart</button>
        <select value={userId} onChange={(e) => setUserId(parseInt(e.target.value))}>
          <option value="1">User 1 (admin)</option>
          <option value="2">User 2</option>
          <option value="3">User 3</option>
        </select>
      </nav>
      {showCart ? (
        <Cart userId={userId} />
      ) : (
        <div>
          <h1>Products</h1>
          <ul>
            {products.map(p => (
              <li key={p.id}>
                {p.name} - ${p.price}
                <button onClick={() => addToCart(p.id)}>Add to Cart</button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

export default App;