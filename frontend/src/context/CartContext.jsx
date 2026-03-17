import { createContext, useContext, useReducer } from 'react';

const CartContext = createContext(null);

function cartReducer(state, action) {
  switch (action.type) {
    case 'ADD': {
      const { product } = action;
      const existing = state.find((i) => i.product_id === product.product_id);
      if (existing) {
        return state.map((i) =>
          i.product_id === product.product_id ? { ...i, qty: i.qty + 1 } : i
        );
      }
      return [...state, { ...product, qty: 1 }];
    }
    case 'REMOVE':
      return state.filter((i) => i.product_id !== action.productId);
    case 'UPDATE_QTY': {
      const { productId, qty } = action;
      if (qty <= 0) return state.filter((i) => i.product_id !== productId);
      return state.map((i) =>
        i.product_id === productId ? { ...i, qty } : i
      );
    }
    case 'CLEAR':
      return [];
    default:
      return state;
  }
}

export function CartProvider({ children }) {
  const [cart, dispatch] = useReducer(cartReducer, []);

  const addToCart = (product) => dispatch({ type: 'ADD', product });
  const removeFromCart = (productId) => dispatch({ type: 'REMOVE', productId });
  const updateQty = (productId, qty) => dispatch({ type: 'UPDATE_QTY', productId, qty });
  const clearCart = () => dispatch({ type: 'CLEAR' });

  const cartCount = cart.reduce((sum, i) => sum + i.qty, 0);
  const cartTotal = cart.reduce((sum, i) => sum + (i.effective_price ?? i.price) * i.qty, 0);

  const value = {
    cart,
    addToCart,
    removeFromCart,
    updateQty,
    clearCart,
    cartCount,
    cartTotal,
  };

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart must be used within CartProvider');
  return ctx;
}
