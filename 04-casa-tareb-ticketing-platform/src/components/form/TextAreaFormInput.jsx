import { FormControl, FormGroup, FormLabel, FormText } from 'react-bootstrap';
import Feedback from 'react-bootstrap/esm/Feedback';
import { Controller } from 'react-hook-form';
const TextAreaFormInput = ({
  name,
  rows = 3,
  containerClass,
  control,
  helpText,
  id,
  label,
  noValidate,
  ...other
}) => {
  return <Controller name={name} defaultValue={''} control={control} render={({
    field,
    fieldState
  }) => <FormGroup className={containerClass ?? ''}>
          {label && <FormLabel>{label}</FormLabel>}
          <FormControl id={id} rows={rows} as="textarea" {...other} {...field} isInvalid={Boolean(fieldState.error?.message)} />
          {helpText && <FormText id={`${id}-help`}>{helpText}</FormText>}
          {!noValidate && fieldState.error?.message && <Feedback type="invalid">{fieldState.error?.message}</Feedback>}
        </FormGroup>} />;
};
export default TextAreaFormInput;