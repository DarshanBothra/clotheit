import { useCart } from '../context/CartContext'

export default function ProductCard({ product }) {
  const { addToCart } = useCart()
  const {
    id,
    name,
    vendor,
    brand,
    price,
    discount = 0,
    effective_price,
    stock = 0,
  } = product

  const priceValue = effective_price ?? price ?? 0
  const isOutOfStock = stock === 0

  const handleAddToCart = () => {
    addToCart({ ...product, product_id: id })
  }

  const stockColor =
    stock > 100 ? 'text-emerald-600' : stock > 0 ? 'text-amber-600' : 'text-red-600'

  return (
    <div className="bg-white rounded-xl shadow-sm hover:shadow-md transition overflow-hidden">
      <div className="relative h-32 flex items-end p-4 bg-gradient-to-r from-indigo-500 to-purple-500">
        {discount > 0 && (
          <span className="absolute top-2 right-2 bg-rose-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">
            {discount}% OFF
          </span>
        )}
        <h3 className="text-white font-semibold text-lg">{name}</h3>
      </div>
      <div className="p-4">
        <p className="text-sm text-slate-500">
          {vendor}
          {brand ? ` (${brand})` : ''}
        </p>
        <div className="mt-2 flex items-baseline gap-2">
          <span className="text-lg font-bold text-slate-900">
            ₹{priceValue.toFixed(2)}
          </span>
          {discount > 0 && (
            <span className="text-sm text-slate-400 line-through">
              ₹{(price ?? 0).toFixed(2)}
            </span>
          )}
        </div>
        <p className={`text-xs mt-1 ${stockColor}`}>
          {stock > 0 ? `In Stock (${stock})` : 'Out of Stock'}
        </p>
        <button
          onClick={handleAddToCart}
          disabled={isOutOfStock}
          className="w-full mt-3 bg-indigo-600 hover:bg-indigo-700 disabled:bg-slate-300 disabled:cursor-not-allowed text-white py-2 rounded-lg font-medium transition"
        >
          Add to Cart
        </button>
      </div>
    </div>
  )
}
