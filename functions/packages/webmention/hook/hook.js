function main(args) {
	const { secret, source, target } = args;

	if ([secret, source, target].includes(undefined)) {
		console.error(`
			Error parsing arguments.
			
			- secret: ${secret}
			- source: ${source}
			- target: ${target}

		`);
		return;
	}

	if (args.deleted) {
		return deleteWebmention({ secret, source, target });
	}

	if (!validateArgs(args)) {
		return;
	}

	createWebmention(args);
}

function validateArgs(args) {
	validateStringProperty(args, 'post');
	validateStringProperty(args.post, 'type');
	validateStringProperty(args.post, 'author');
	validateStringProperty(args.post.author, 'name');
	validateStringProperty(args.post.author, 'photo');
	validateStringProperty(args.post.author, 'url');
	validateStringProperty(args.post, 'url');
	validateStringProperty(args.post, 'published');
	validateStringProperty(args.post, 'name');
	validateStringProperty(args.post, 'repost-of');
	validateStringProperty(args.post, 'wm-property');
}

function validateStringProperty(obj, key) {
	if (!(key in obj && typeof obj[key] === 'string')) {
		return false;
	} 
}
