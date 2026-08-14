import { FormControl, FormGroup, FormLabel, FormText } from 'react-bootstrap';
import Feedback from 'react-bootstrap/esm/Feedback';
import { Controller } from 'react-hook-form';
const TextFormInput = ({
  name,
  containerClass,
  control,
  helpText,
  id,
  label,
  noValidate,
  combinedInput,
  ...other
}) => {
  return <Controller name={name} defaultValue={''} control={control} render={({
    field,
    fieldState
  }) => combinedInput ? <FormControl id={id} {...other} {...field} isInvalid={Boolean(fieldState.error?.message)} /> : <FormGroup className={containerClass ?? ''}>
            {label && <FormLabel>{label}</FormLabel>}
            <FormControl id={id} {...other} {...field} isInvalid={Boolean(fieldState.error?.message)} />
            {helpText && <FormText id={`${id}-help`}>{helpText}</FormText>}
            {!noValidate && fieldState.error?.message && <Feedback type="invalid">{fieldState.error?.message}</Feedback>}
          </FormGroup>} />;
};
export default TextFormInput;