import Button from "../../Components/Input/Button";
import { useState } from "react";

function ShowData() {
  const [thead] = useState([
    "ID",
    "Image",
    "Product",
    "Category",
    "Amount",
    "Action",
  ]);
  
  const [tbody] = useState([
    {
      id: "1",
      image: "1.jpg",
      product: "T-shirt",
      category: "T-shirt",
      amount: "1000",
    },
    {
      id: "2",
      image: "1.jpg",
      product: "T-shirt",
      category: "T-shirt",
      amount: "1000",
    },
    {
      id: "3",
      image: "1.jpg",
      product: "T-shirt",
      category: "T-shirt",
      amount: "1000",
    },
  ]);

  return (
    <div className="p-10 overflow-x-auto">
      {/* The wrapper lets you scroll horizontally without shrinking the table */}
      <table className="min-w-full border">
        <thead>
          <tr>
            {thead.map((head, index) => (
              <th key={index} className="border-y text-start px-4 py-2">
                {head}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {tbody.map((item, rowIndex) => (
            <tr className="border-y h-max " key={rowIndex}>
              <td className="px-4 py-2">{item.id}</td>
              <td className="px-4 py-2">
                <img src={`/images/${item.image}`} alt="Product Image" width="50" />
              </td>
              <td className="px-4 py-2">{item.product}</td>
              <td className="px-4 py-2">{item.category}</td>
              <td className="px-4 py-2">{item.amount}</td>
             <td className="px-4 py-2 align-middle">
                <div className="flex  items-center">
                    <Button label="Edit" className="bg-blue-600 mr-2" children={undefined} />
                    <Button label="Delete" className="bg-red-600" children={undefined} />
                </div>
            </td>

            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default ShowData;
