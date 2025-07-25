import FormLayout from "../../../../../resources/components/common/FormLayout";
import type { ApiList, Field } from "../../../../../resources/components/common/commonform";
import { useState } from "react";
import invoice from "../../../public/Invoice.json";

function Purchase() {
  const fieldSection = invoice.invoice.purchase;
  const head = Object.values(fieldSection)
    .flatMap((section: any) => section.fields)
    .filter((field: any) => field.inTable);

  const groupedFields = Object.entries(fieldSection).map(
    ([sectionKey, section]) => ({
      title: section.title || sectionKey,
      sectionKey,
      fields: section.fields
        .filter(
          (field: any) =>
            field.key !== "action" &&
            field.key !== "id" &&
            field.isForm === true
        )
        .map((field: any) => ({
          id: field.key,
          label: field.label,
          type: (field.type || "textinput") as Field["type"],
          className: "w-full",
          errMsg: `Enter ${field.label}`,
          ...(field.type?.includes("dropdown") && field.options
            ? { options: field.options }
            : {}),
          readApi: field.readApi,
          updateApi: field.updateApi,
          apiKey: field.apiKey,
          createKey: field.createKey,
        })),
    })
  );
  const printableFields = Object.values(fieldSection).flatMap((section: any) =>
    section.fields.filter((field: any) => field.isPrint === true)
  );
  const [formApi] = useState<ApiList>({
    create: "/api/purchases",
    read: "/api/purchases",
    update: "/api/purchases",
    delete: "/api/purchases",
  });
  return (
    <div>
      <FormLayout
        groupedFields={groupedFields}
        head={head}
        formApi={formApi}
        printableFields={printableFields}
      />
    </div>
  );
}

export default Purchase;
