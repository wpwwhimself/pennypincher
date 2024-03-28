export default (val?: number) =>
  val?.toLocaleString(
    "pl-PL",
    {
      style: "currency",
      currency: "PLN",
    }
  )