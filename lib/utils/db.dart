F? tryToParse<F, O>(O? rawData, F Function(O) parser) =>
    rawData == null ? null : parser(rawData);
