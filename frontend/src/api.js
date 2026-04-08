async function apiFetch(path, options = {}) {
  const res = await fetch(`/api${path}`, {
    headers: { 'Content-Type': 'application/json', ...options.headers },
    ...options,
  });
  if (!res.ok) {
    const err = new Error(res.statusText || 'API error');
    err.status = res.status;
    throw err;
  }
  return res.json();
}

export function fetchCustomers() {
  return apiFetch('/customers');
}

export function fetchCustomer(id) {
  return apiFetch(`/customers/${id}`);
}

export function fetchProducts(tag) {
  const qs = tag ? `?tag=${encodeURIComponent(tag)}` : '';
  return apiFetch(`/products${qs}`);
}

export function fetchTags() {
  return apiFetch('/tags');
}

export function placeOrder(customerId, items) {
  return apiFetch('/orders', {
    method: 'POST',
    body: JSON.stringify({ customer_id: customerId, items }),
  });
}

export function fetchOrders(customerId) {
  const qs = customerId != null ? `?customer_id=${encodeURIComponent(customerId)}` : '';
  return apiFetch(`/orders${qs}`);
}

export function fetchOrder(id) {
  return apiFetch(`/orders/${id}`);
}

export function fetchLowStock(threshold) {
  const qs = threshold != null ? `?threshold=${encodeURIComponent(threshold)}` : '';
  return apiFetch(`/analytics/low-stock${qs}`);
}

export function fetchCustomerAnalytics() {
  return apiFetch('/analytics/customers');
}

export function fetchVendorAnalytics() {
  return apiFetch('/analytics/vendors');
}

export function fetchMonthlyAnalytics() {
  return apiFetch('/analytics/monthly');
}

export function fetchTopProducts(limit) {
  const qs = limit != null ? `?limit=${encodeURIComponent(limit)}` : '';
  return apiFetch(`/analytics/top-products${qs}`);
}

export function fetchComplaints() {
  return apiFetch('/analytics/complaints');
}

export function cancelOrder(orderId) {
  return apiFetch(`/orders/${orderId}/cancel`, { method: 'PUT' });
}
