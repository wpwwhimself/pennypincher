interface Account {
  id: number,
  name: string,
  description?: string,
  color: string,
  created_at: Date,
  updated_at: Date,
  balance: number,
}

interface Category {
  id: number,
  name: string,
  description?: string,
  color: string,
  parent_id?: number,
  parent?: Category,
  subcategories?: Category[],
  created_at: Date,
  updated_at: Date, 
}

interface Transaction {
  id: number,
  date: Date,
  category_id: number,
  category: Category,
  account_id: number,
  account: Account,
  description?: string,
  amount: number,
  created_at: Date,
  updated_at: Date, 
}

interface Pagination {
  data: any[],
  pageCount: number,
}