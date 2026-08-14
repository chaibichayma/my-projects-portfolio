import Choices from 'choices.js';
import { useEffect, useRef } from 'react';
const SelectFormInput = ({
  children,
  multiple,
  className,
  onChange,
  ...choiceOptions
}) => {
  const selectE = useRef(null);
  useEffect(() => {
    if (selectE.current) {
      const choices = new Choices(selectE.current, {
        ...choiceOptions,
        allowHTML: true,
        shouldSort: false
      });
      choices.passedElement.element.addEventListener('change', e => {
        if (!(e.target instanceof HTMLSelectElement)) return;
        if (onChange) {
          onChange(e.target.value);
        }
      });
    }
  }, [selectE]);
  return <select ref={selectE} multiple={multiple} className={className}>
      {children}
    </select>;
};
export default SelectFormInput;