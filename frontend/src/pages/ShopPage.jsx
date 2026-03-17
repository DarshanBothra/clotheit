import { useState, useEffect } from 'react'
import { fetchProducts, fetchTags } from '../api'
import ProductCard from '../components/ProductCard'
import TagFilter from '../components/TagFilter'

export default function ShopPage({ customerId }) {
  const [products, setProducts] = useState([])
  const [tags, setTags] = useState([])
  const [selectedTag, setSelectedTag] = useState(null)
  const [searchQuery, setSearchQuery] = useState('')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchTags().then((tagList) => setTags(tagList ?? []))
  }, [])

  useEffect(() => {
    setLoading(true)
    fetchProducts(selectedTag)
      .then(setProducts)
      .finally(() => setLoading(false))
  }, [selectedTag])

  const filtered = products.filter((p) => {
    if (!searchQuery.trim()) return true
    const q = searchQuery.toLowerCase()
    return (
      (p.name ?? '').toLowerCase().includes(q) ||
      (p.vendor ?? '').toLowerCase().includes(q) ||
      (p.brand ?? '').toLowerCase().includes(q)
    )
  })

  return (
    <div className="min-h-screen bg-slate-50 p-6">
      <h1 className="text-2xl font-bold text-slate-800 mb-6">Shop</h1>

      <div className="mb-6">
        <input
          type="text"
          placeholder="Search products..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full max-w-md rounded-lg border border-slate-200 px-4 py-2 text-slate-700 placeholder-slate-400 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        />
        <div className="mt-3">
          <TagFilter tags={tags} selected={selectedTag} onSelect={setSelectedTag} />
        </div>
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-16 text-slate-500">
          Loading...
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-16 text-slate-500">
          No products match your filters.
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filtered.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  )
}
