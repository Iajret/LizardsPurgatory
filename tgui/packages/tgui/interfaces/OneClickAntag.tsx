import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  roundstarts: string[];
  midrounds: string[];
  ghostroles: string[];
};

export const OneClickAntag = (props) => {
  const { data } = useBackend<Data>();
  const { roundstarts, midrounds, ghostroles } = data;
  return (
    <Window
      title="Quick-Create Antagonist"
      width={400}
      height={500}
      theme="admin"
    >
      <Window.Content scrollable>
        <AntagonistList
          title="Roundstart Antagonists"
          antagonists={roundstarts}
        />
        <AntagonistList title="Midround Antagonists" antagonists={midrounds} />
        <AntagonistList
          title="Ghost Role Antagonists"
          antagonists={ghostroles}
        />
      </Window.Content>
    </Window>
  );
};

const AntagonistList = (props: { title: string; antagonists: string[] }) => {
  const { act } = useBackend();
  const { title, antagonists } = props;
  return (
    <Section title={title}>
      {antagonists.sort().map((antag_name: string) => (
        <Button
          key={antag_name}
          onClick={() => act('createAntag', { name: antag_name })}
        >
          {antag_name}
        </Button>
      ))}
    </Section>
  );
};
