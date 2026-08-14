import clsx from 'clsx';
import { useState } from 'react';
import { FormControl, FormGroup, FormLabel, FormText } from 'react-bootstrap';
import Feedback from 'react-bootstrap/esm/Feedback';
import { Controller } from 'react-hook-form';
import { FaEye, FaEyeSlash } from 'react-icons/fa6';
const PasswordFormInput = ({
  name,
  containerClass,
  control,
  helpText,
  id,
  label,
  noValidate,
  ...other
}) => {
  const [showPassword, setShowPassword] = useState(false);
  return <Controller name={name} defaultValue={''} control={control} render={({
    field,
    fieldState
  }) => <FormGroup className={clsx('position-relative', containerClass ?? '')}>
          {label && <FormLabel>{label}</FormLabel>}
          <FormControl id={id} type={showPassword ? 'text' : 'password'} isInvalid={Boolean(fieldState.error?.message)} {...other} {...field} />
          <span className="position-absolute top-50 end-0 translate-middle-y pe-2 mt-3" onClick={() => setShowPassword(!showPassword)} role="button">
            {!fieldState.error && (showPassword ? <FaEyeSlash size={18} className="cursor-pointer" /> : <FaEye size={18} className="cursor-pointer" />)}
          </span>
          {helpText && <FormText id={`${id}-help`}>{helpText}</FormText>}
          {!noValidate && fieldState.error?.message && <Feedback type="invalid">{fieldState.error?.message}</Feedback>}
        </FormGroup>} />;
};
export default PasswordFormInput;