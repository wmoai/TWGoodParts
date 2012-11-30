# UIButton+TWSupport

Provides easy way for with gradient, highlight by extending UIButton.

## Usage

The Following is how to create simple gradient button with highlight.

```objective-c
#import "UIButton+TWSupport.h"

UIButton *button = [UIButton buttonWithGradient:CGRectMake(0,0,50,100)];
```

The Other way, button can change gradient button after build instance.

```objective-c
#import "UIButton+TWSupport.h"

UIButton *button = [UIButton buttonWithType:UIButtonCustomType];
[button setTypeWithGradient:CGRectMake(0,0,50,100)];
```

## Contributing to TWGoodParts

- Fork, fix, then send me a pull request.

## License

- Soon. Probably MIT-License.
