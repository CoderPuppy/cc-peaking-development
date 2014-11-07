# FS

- `fs(ctx, path, op, args...): promise`

## Operations
### stat
__Returns:__
```lua
{
	exists = boolean;
	type = 'block'|'stream'|'api'|'directory';
	owner = groupname;
	perms = {
		'all' = perms;
		[{'user', username}] = perms;
		[{'group', username}] = perms;
	};
}
```

__`perms`:__
```lua
{
	read = boolean;
	write = boolean;
	execute = boolean; -- Only for block and API files
	list = boolean; -- Only for directories
}
```

### open(mode): handle
__`mode`:__
```lua
{
	read = true|false;
	write = true|false;
	binary = true|false; -- Only for block files
}
```
- `move(dir)`
- `rename(newName)`
- `movename(dir, newName)`
- `delete()` - Needs to error if the path is a directory and has files in it

# Handle

- `close(): promise`

## Block
- `seek(offset): promise`
- `getOffset(): promise[offset]`
- `read(length): promise[data]`
- `write(data): promise[writen]`

## Stream
- `read(): promise[msg]`
- `write(msg): promise`

## API
- `call(name, arg...): promise[res]`
- `list(): promise[{{name, arg...}...}]`
- `read(): promise[id, name, arg...]`
- `respond(id, res...): promise`

## Directory
- `next(): promise[string]` - get the name of the next file