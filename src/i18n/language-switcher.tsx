'use client';

import { usePathname, useRouter } from '@/navigation';
import { useLocale } from 'next-intl';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

export function LanguageSwitcher() {
  const router = useRouter();
  const pathname = usePathname();
  const locale = useLocale();

  const onSelectChange = (value: string) => {
    router.replace(pathname, { locale: value });
  };

  return (
    <Select value={locale} onValueChange={onSelectChange}>
      <SelectTrigger className="w-auto border-none bg-transparent text-xs text-muted-foreground shadow-none focus:ring-0">
        <SelectValue placeholder="Language" />
      </SelectTrigger>
      <SelectContent>
        <SelectItem value="en">English</SelectItem>
        <SelectItem value="pt-br">Português</SelectItem>
      </SelectContent>
    </Select>
  );
}
