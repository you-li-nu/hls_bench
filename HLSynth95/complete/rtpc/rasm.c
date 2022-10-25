#include <stdio.h>
#include <string.h>

#define DATA -97
#define STRING -98
#define COMMENT -99

typedef unsigned long dec;
typedef struct _instr_type
{
	char mnemonic[10];
	dec opcode;
	dec num_of_param;
	dec num_of_parts;
	char param_type[5];
	dec param_order[5];
	dec param_bits[5];
} instr_type;

instr_type instr_bank[200];
dec number[5];

dec work;
dec debugging;
dec address_deb;
dec bank_size=0;

char read_line[200];
char unaltered[200];
char *field;

FILE *prog;

dec write_comp;				/* 0=write, 1=compare */
dec num_of_instr,num_of_instr_bytes;
dec num_of_data_bytes;
dec num_of_comp_bytes;
dec num_of_control;

char *tabs2spaces(in)
char *in;
{
	int len,from,to,can_seperate;

	len=strlen(in);
	can_seperate=0;
	to=0;
	for(from=0;from<len;from++)
	{
		if (in[from]=='\t')
		{
			if (can_seperate) in[to++]=' ';
			can_seperate=0;
		}
		else
		{
			in[to++]=in[from];
			can_seperate=1;
		}
	}
	if (can_seperate) in[to]=0;
	else in[to-1]=0;
}

void standardize_line()
{
	int len,from,to,can_seperate;

	strcpy(unaltered,read_line);

	if (read_line[0]=='"') return;

	len=strlen(read_line);
	can_seperate=0;
	to=0;
	for(from=0;from<len;from++)
	{
		if ((read_line[from]==' ')||
		(read_line[from]=='(')||
		(read_line[from]==')')||
		(read_line[from]=='.')||
		(read_line[from]==',')||
		(read_line[from]==':')||
		(read_line[from]==';')||
		(read_line[from]=='\t')||
		(read_line[from]=='\n'))
		{
			if (can_seperate) read_line[to++]=',';
			can_seperate=0;
		}
		else
		{
			read_line[to++]=toupper(read_line[from]);
			can_seperate=1;
		}
	}
	if (can_seperate) read_line[to]=0;
	else read_line[to-1]=0;
}

int move_line_to_bank()
{
	int i;
	int paramnum,bitnum;

	field=strtok(read_line,",");
	strcpy(instr_bank[bank_size].mnemonic,field);

	field=strtok(NULL,",");
	instr_bank[bank_size].opcode=atol(field);

	paramnum=0;
	field=strtok(NULL,",");
	while ((field!=NULL)&&((((*field)>='A')&&((*field)<='Z'))||(((*field)=='#'))))
	{
		instr_bank[bank_size].param_type[paramnum]=*field;
		instr_bank[bank_size].param_order[paramnum]=atol(&field[1]);
		paramnum++;
		field=strtok(NULL,",");
	}

	bitnum=0;
	while ((field!=NULL)&&((*field)>='0')&&((*field)<='9'))
	{
		instr_bank[bank_size].param_bits[bitnum]=atol(field);
		bitnum++;
		field=strtok(NULL,",");
	}

	instr_bank[bank_size].num_of_param=paramnum;
	instr_bank[bank_size].num_of_parts=bitnum;

	bank_size++;
	return(0);
}

void convert_line()
{
	int i;

	work=STRING;
	if (read_line[0]=='"') return;
	work=DATA;
	if (read_line[0]=='=') return;
	work=COMMENT;

	field=strtok(read_line,",");
	if (field==NULL) return;
	for(i=0;i<bank_size;i++)
	{
		if (!strcmp(instr_bank[i].mnemonic,field)) break;
		if ((instr_bank[i].param_bits[0]==0)&&(!strncmp(instr_bank[i].mnemonic,field,3))) break;
	}
	if (i==bank_size) return;
	work=i;

	if (instr_bank[i].param_bits[0]==0)
	{
		if (!strncmp(instr_bank[i].mnemonic,"WRI",3)) write_comp=0;
		if (!strncmp(instr_bank[i].mnemonic,"COM",3)) write_comp=1;
	}

	for(i=0;i<instr_bank[work].num_of_param;i++)
	{
		field=strtok(NULL,",");
		if (field==NULL) { work=COMMENT; return; }
		if (instr_bank[work].param_type[i]=='#')
		{
			sscanf(field,"%i",&number[i]);
			if (!strncmp(instr_bank[work].mnemonic,"@")) address_deb=number[i];
		}
		else number[i]=atol(&field[1]);
	}
}

dec modulo_bits(b,n)
dec b,n;
{
	dec i,num;
	
	num=1;
	for(i=0;i<b;i++) num=num*2;

	return(n%num);
}

void print_out_instr()
{
	int i,j;
	dec decid,bitwidth,byte,use_number;
	char str[20];

	if (instr_bank[work].param_bits[0]==0)
	{
		fprintf(prog,"%s",instr_bank[work].mnemonic);
		for(i=0;i<instr_bank[work].num_of_param;i++) fprintf(prog," %X",number[i]);
		fprintf(prog,"\n");

		num_of_control++;

		return;
	}

	decid=0;
	bitwidth=0;
	for(i=0;i<instr_bank[work].num_of_parts+1;i++)
	{
		for(j=0;j<instr_bank[work].num_of_param;j++)
		{
			if (!i)
			{
				use_number=instr_bank[work].opcode;
				break;
			}
			else
			{
				if (instr_bank[work].param_order[j]==i)
				{
					use_number=number[j];
					break;
				}
			}
		}
		if (j==instr_bank[work].num_of_param) use_number=0;

		decid=decid<<instr_bank[work].param_bits[i];
		decid=decid|modulo_bits(instr_bank[work].param_bits[i],use_number);
		bitwidth=bitwidth+instr_bank[work].param_bits[i];
	}

	for(i=0;i<bitwidth/4;i++)
	{
		sprintf(&str[i],"%X",modulo_bits(4,decid));
		decid=decid>>4;
	}

	byte=0;
	for(i=bitwidth/4;i>0;i--)
	{
		if (byte==2) { fprintf(prog," "); byte=0; }
		fprintf(prog,"%c",str[i-1]);
		byte=byte+1;
	}

	if (debugging==1)
	{
		if (bitwidth<32) fprintf(prog,"      ");
		fprintf(prog,"\t-- x%X %s",address_deb,tabs2spaces(unaltered));
	}
	else fprintf(prog,"\n");

	address_deb+=bitwidth/8;

	num_of_instr++;
	num_of_instr_bytes+=bitwidth/8;
}

void print_out_string()
{
	int i,j;
	char str[10];

	str[0]=0;
	for(i=1;i<strlen(read_line);i++)
	{
		if ((read_line[i]=='"')||(read_line[i]=='\n')) { i++; break; }
		if (i!=1)
		{
			if (((i-1)%4)==0)
			{
				if (debugging==1)
				{
					fprintf(prog,"\t-- x%X \"%s\"\n",address_deb,str);
					address_deb+=4;
				}
				else fprintf(prog,"\n");
			}
			else fprintf(prog," ");
		}
		fprintf(prog,"%02X",read_line[i]);
		str[(i-1)%4]=read_line[i];
		str[(i-1)%4+1]=0;

		if (write_comp==0) num_of_data_bytes++; else num_of_comp_bytes++;
	}

	if (debugging==1)
	{
		if (((i-2)%4)!=0)
		{
			for(j=((i-2)%4)*3-1;j<11;j++) fprintf(prog," ");
		}

		fprintf(prog,"\t-- x%X \"%s\"\n",address_deb,str);
	}
	else fprintf(prog,"\n");

	address_deb+=(i-3)%4+1;
}

void print_out_data()
{
	int decid,incr=0,i=1;

	field=strtok(&read_line[1],",");
	while(field!=NULL)
	{
		if (sscanf(field,"%i",&decid)==0) break;

		if ((read_line[i]=='"')||(read_line[i]=='\n')) { i++; break; }
		if (i!=1)
		{
			if (((i-1)%4)==0)
			{
				if (debugging==1) fprintf(prog," -- x%X\n",address_deb);
				else fprintf(prog,"\n");

				address_deb+=incr;
				incr=0;
			}
			else fprintf(prog," ");
		}
		fprintf(prog,"%02X",decid);
		field=strtok(NULL,",");
		incr++;
		i++;

		if (write_comp==0) num_of_data_bytes++; else num_of_comp_bytes++;
	}
	if (debugging==1) fprintf(prog," -- x%X\n",address_deb);
	else fprintf(prog,"\n");

	address_deb+=incr;
}

main(argc,argv)
int argc;
char *argv[];
{
	int i;
	int linnum;
	char skranafn[100];
	FILE *bank,*fp;

	if (argc<2) { printf("missing filename\n"); exit(0); }

	strcpy(read_line,argv[1]);
	standardize_line();

	if (argc>2)
	{
		if (strcmp(argv[1],"-d")) { printf("-d is the only allowed switch"); exit(0); }
		debugging=1;

		strcpy(read_line,argv[2]);
		standardize_line();
	}

	prog=fopen("program","w");
	if (prog==NULL) { printf("can't open program-file\n"); exit(0); }

	field=strtok(read_line,",");
	field=strtok(NULL,",");
	if (field==NULL) strcat(unaltered,".asm");
	else
	{
		if (strcmp(field,"ASM")) strcat(unaltered,".asm");
	}

	fp=fopen(unaltered,"r");
	if (fp==NULL) { printf("can't open assembly-file %s\n",unaltered); exit(0); }
	strcpy(skranafn,unaltered);

	bank=fopen("rasm.instr","r");
	if (bank==NULL) { printf("can't open rasm.instr\n"); exit(0); }

	linnum=0;
	while(!feof(bank))
	{
		linnum++;
		if (fgets(read_line,200,bank)==NULL) break;

		if (read_line[0]!='\n')
		{
			standardize_line();
			if (move_line_to_bank()==-1) { printf("Error in rtpc-ass.instr, line %d\n",linnum); exit(0); }
		
/*			printf("%s,%d",instr_bank[bank_size-1].mnemonic,
				instr_bank[bank_size-1].opcode);
			for(i=0;i<instr_bank[bank_size-1].num_of_param;i++)
			{
				printf(",%c%d",instr_bank[bank_size-1].param_type[i],instr_bank[bank_size-1].param_order[i]);
			}
			for(i=0;i<instr_bank[bank_size-1].num_of_parts;i++)
			{
				printf(",%d",instr_bank[bank_size-1].param_bits[i]);
			}
			printf("\n"); */
		}
	}
	fclose(bank);

	linnum=0;
	while (!feof(fp))
	{
		linnum++;
		if (fgets(read_line,200,fp)==NULL) break;

		if (read_line[0]!='\n')
		{
			standardize_line();
			convert_line();
			switch (work)
			{
				case STRING: print_out_string(); break;
				case DATA: print_out_data(); break;
				case COMMENT: if (debugging==1) fprintf(prog,"%s",unaltered); break;
				default: print_out_instr(); break;
			}
		}
		else
		{
			if (debugging==1) fprintf(prog,"\n");
		}
	}
	fclose(fp);
	fclose(prog);

	fprintf(stderr,"\nAssembly-file...............: %s\n\n",skranafn);
	fprintf(stderr,"Number of Instructions......: %d\n",num_of_instr);
	fprintf(stderr,"Number of Instruction Bytes.: %d\n",num_of_instr_bytes);
	fprintf(stderr,"Number of Data Bytes........: %d\n",num_of_data_bytes);
	fprintf(stderr,"Number of Comparing Bytes...: %d\n",num_of_comp_bytes);
	fprintf(stderr,"Number of Control lines.....: %d\n\n",num_of_control);

}
