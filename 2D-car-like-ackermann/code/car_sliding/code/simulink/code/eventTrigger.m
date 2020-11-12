function event_bool = eventTrigger(val, MAX_VAL)
    event_bool = (val == -MAX_VAL)|(val == MAX_VAL);
end