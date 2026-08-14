import flatpickr from 'flatpickr';
import { useCallback, useEffect, useRef } from 'react';
const Flatpicker = ({
  className,
  options,
  placeholder,
  value,
  getValue
}) => {
  const element = useRef(null);
  const handleDateChange = useCallback(selectedDates => {
    const newDate = selectedDates.length === 1 ? selectedDates[0] : selectedDates;
    getValue?.(newDate);
  }, [getValue]);
  useEffect(() => {
    if (element.current) {
      const instance = flatpickr(element.current, {
        defaultDate: value,
        ...options,
        onChange: selectedDates => handleDateChange(selectedDates)
      });
      return () => {
        instance.destroy();
      };
    }
  }, [value, options, handleDateChange]);
  return <input ref={element} className={`form-control flatpickr ${className}`} placeholder={placeholder} />;
};
export default Flatpicker;