The main documentation is in doc/quickjs.pdf or doc/quickjs.html.

## build.zig

`zig-0.13.0`

`x86-windows` OK

```
> zig build

> .\zig-out\bin\qjs.exe --help
QuickJS version 2024-02-14
usage: qjs [options] [file [args]]
-h  --help         list options
-e  --eval EXPR    evaluate EXPR
-i  --interactive  go to interactive mode
-m  --module       load as ES6 module (default=autodetect)
    --script       load as ES6 script (default=autodetect)
-I  --include file include an additional file
    --std          make 'std' and 'os' available to the loaded script
    --bignum       enable the bignum extensions (BigFloat, BigDecimal)
    --qjscalc      load the QJSCalc runtime (default if invoked as qjscalc)
-T  --trace        trace memory allocation
-d  --dump         dump the memory usage stats
    --memory-limit n       limit the memory usage to 'n' bytes
    --stack-size n         limit the stack size to 'n' bytes
    --unhandled-rejection  dump unhandled promise rejections
-q  --quit         just instantiate the interpreter and quit
```

## workaround

### Illegal instruction: container_of 

- [zig build with safety on get &quot;Illegal instruction&quot; when using c &quot;container_of&quot; · Issue #15962 · ziglang/zig · GitHub](https://github.com/ziglang/zig/issues/15962)
