func pipe(
  _ transforms: RequestTransform...
) -> RequestTransform {
  {
    try transforms.reduce($0) { partialRequest, transform in
      try transform(partialRequest)
    }
  }
}
